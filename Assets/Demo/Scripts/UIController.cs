using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class UIController : MonoBehaviour
{
    static UIController _instance;

    [SerializeField] GameObject Background;
    [SerializeField] GameObject QuitDialog;
    [SerializeField] Text ScoreText;
    [SerializeField] Text TimeText;
    [SerializeField] GameObject gameoverPanel;
    [SerializeField] Text gameoverScoreText;
    [SerializeField] Text gameoverTimeText;
    [SerializeField] PlayableDirector endAnim;

    public static UIController instance { get => _instance; }

    private void Awake()
    {
        _instance = this;
        SetScore(0);
        UpdateTime(0);
    }

    public void OnQuitGame()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }

    public void OnResume()
    {
        Background.SetActive(false);
        QuitDialog.SetActive(false);
        Time.timeScale = 1f;
    }

    public void ShowQuitDialog()
    {
        if (gameoverPanel.activeSelf)
            return;
        Time.timeScale = 0;
        Background.SetActive(true);
        QuitDialog.SetActive(true);
    }

    public void SetScore(int score)
    {
        ScoreText.text = score.ToString();
    }

    public void UpdateTime(float seconds)
    {
        if (TimeText)
            SetFormattedTime(TimeText, seconds);
    }

    public void OnGameOver(int score, float time)
    {
        gameoverPanel.SetActive(true);
        gameoverScoreText.text = score.ToString();
        SetFormattedTime(gameoverTimeText, time);
        endAnim.Play();
    }

    void SetFormattedTime(Text textWidget, float seconds)
    {
        var t = System.TimeSpan.FromSeconds(seconds);
        var fontsize = TimeText.fontSize;
        textWidget.text = string.Format("<size={3:00}>{0:00}:{1:00}</size><size={4:00}>:{2:00.}</size>",
            t.Minutes, t.Seconds, t.Milliseconds / 10, fontsize, Mathf.CeilToInt(fontsize * 0.8f)
            );
    }

    private void Update()
    {
        // handle exit & restart
        if (gameoverPanel.activeSelf)
        {
            if (Input.GetButton("Cancel"))
                OnQuitGame();
            if (Input.GetButton("Restart"))
                SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        }

        // handle resume. nope, it will open and instantly close it right away
        //if (QuitDialog.activeSelf && Input.GetButton("Cancel"))
        //    OnResume();
    }
}
